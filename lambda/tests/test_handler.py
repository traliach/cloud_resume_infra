import json
import os
from unittest.mock import MagicMock, patch

import pytest

os.environ["TABLE_NAME"] = "test-visitors"
os.environ["ALLOWED_ORIGIN"] = "resume.achille.tech"


@pytest.fixture(autouse=True)
def mock_dynamodb_table():
    with patch("handler.table") as mock_table:
        mock_table.update_item.return_value = {
            "Attributes": {"visit_count": 42}
        }
        yield mock_table


def test_returns_200_with_count(mock_dynamodb_table):
    import handler

    result = handler.lambda_handler({}, {})

    assert result["statusCode"] == 200
    body = json.loads(result["body"])
    assert body["count"] == 42


def test_increments_counter(mock_dynamodb_table):
    import handler

    handler.lambda_handler({}, {})

    mock_dynamodb_table.update_item.assert_called_once_with(
        Key={"id": "visitors"},
        UpdateExpression="ADD visit_count :inc",
        ExpressionAttributeValues={":inc": 1},
        ReturnValues="UPDATED_NEW",
    )


def test_cors_header_set(mock_dynamodb_table):
    import handler

    result = handler.lambda_handler({}, {})

    assert "Access-Control-Allow-Origin" in result["headers"]
    assert "resume.achille.tech" in result["headers"]["Access-Control-Allow-Origin"]


def test_returns_500_on_dynamodb_error(mock_dynamodb_table):
    from botocore.exceptions import ClientError

    import handler

    mock_dynamodb_table.update_item.side_effect = ClientError(
        {"Error": {"Code": "InternalServerError", "Message": "DynamoDB unavailable"}},
        "UpdateItem",
    )

    result = handler.lambda_handler({}, {})

    assert result["statusCode"] == 500
    body = json.loads(result["body"])
    assert "error" in body

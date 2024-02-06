"""Test canister APIs

   First deploy the canister, then run:

   $ pytest --network=[local/ic] test_apis.py

"""

# pylint: disable=unused-argument, missing-function-docstring, unused-import, wildcard-import, unused-wildcard-import, line-too-long

from pathlib import Path
import pytest
from icpp.smoketest import call_canister_api

# Path to the dfx.json file
DFX_JSON_PATH = Path(__file__).parent / "../dfx.json"

# Canister in the dfx.json file we want to test
CANISTER_NAME = "donation_tracker_canister"


def test__whoami_anonymous(identity_anonymous: dict[str, str], network: str) -> None:
    response = call_canister_api(
        dfx_json_path=DFX_JSON_PATH,
        canister_name=CANISTER_NAME,
        canister_method="whoami",
        canister_argument="()",
        network=network,
        timeout_seconds=10,
    )
    expected_response = f'(principal "{identity_anonymous["principal"]}")'
    assert response == expected_response


def test__whoami_default(identity_default: dict[str, str], network: str) -> None:
    response = call_canister_api(
        dfx_json_path=DFX_JSON_PATH,
        canister_name=CANISTER_NAME,
        canister_method="whoami",
        canister_argument="()",
        network=network,
        timeout_seconds=10,
    )
    expected_response = f'(principal "{identity_default["principal"]}")'
    assert response == expected_response


def test__listRecipients_schools_all(identity_anonymous: dict[str, str], network: str) -> None:
    response = call_canister_api(
        dfx_json_path=DFX_JSON_PATH,
        canister_name=CANISTER_NAME,
        canister_method="listRecipients",
        canister_argument='( record {include = "schools"} )',
        network=network,
        timeout_seconds=10,
    )
    # For now, just check the Mock Data is coming back
    expected_response = '(variant { Ok = record { recipients = vec { record { id = "school1"; thumbnail = "thumbnail1.jpg"; name = "School One";}; record { id = "school2"; thumbnail = "thumbnail1.jpg"; name = "School Two";};};} })'
    assert response == expected_response

def test__listRecipients_schools_filter(identity_anonymous: dict[str, str], network: str) -> None:
    response = call_canister_api(
        dfx_json_path=DFX_JSON_PATH,
        canister_name=CANISTER_NAME,
        canister_method="listRecipients",
        canister_argument='( record {include = "students"; recipientIdForSchool = opt "school1"} )',
        canister_input="idl",
        canister_output="idl",
        network=network,
        timeout_seconds=10,
    )
    # For now, just check the Mock Data is coming back
    expected_response = '(variant { Ok = record { recipients = vec { record { id = "school1"; thumbnail = "thumbnail1.jpg"; name = "School One";}; record { id = "student1"; thumbnail = "thumbnail2.jpg"; name = "Student One";};};} })'
    assert response == expected_response
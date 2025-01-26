package Cx

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_storage_account[name]
    public_access := resource.allow_nested_items_to_be_public
    public_access == true

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("azurerm_storage_account[%s].allow_nested_items_to_be_public", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "allow_nested_items_to_be_public should be set to 'false'",
        "keyActualValue": sprintf("allow_nested_items_to_be_public is set to '%t'", [public_access]),
    }
}
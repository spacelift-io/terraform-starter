package Cx

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_storage_container[name]
    public_access := resource.public_access
    public_access == "blob" or public_access == "container"

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("azurerm_storage_container[%s].public_access", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "public_access should be set to 'private'",
        "keyActualValue": sprintf("public_access is set to '%s'", [public_access]),
    }
}
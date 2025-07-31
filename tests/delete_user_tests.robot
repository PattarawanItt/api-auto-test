*** Settings ***
Library           RequestsLibrary

*** Variables ***
${BASE_URL}       https://reqres.in

*** Test Cases ***
Delete User Should Return 204
    Create Session    reqres    ${BASE_URL}
    ${response}=    DELETE    reqres    /api/users/2
    Should Be Equal As Numbers    ${response.status_code}    204

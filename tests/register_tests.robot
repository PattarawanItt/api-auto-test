*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://reqres.in

*** Test Cases ***
Successful Register Should Return ID and Token
    Create Session    reqres    ${BASE_URL}
    ${data}=    Create Dictionary    email=eve.holt@reqres.in    password=pistol
    ${response}=    POST    reqres    /api/register    json=${data}
    Should Be Equal As Numbers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    id
    Dictionary Should Contain Key    ${response.json()}    token

Unsuccessful Register Should Return Error
    Create Session    reqres    ${BASE_URL}
    ${data}=    Create Dictionary    email=sydney@fife
    ${response}=    POST    reqres    /api/register    json=${data}
    Should Be Equal As Numbers    ${response.status_code}    400
    Dictionary Should Contain Key    ${response.json()}    error

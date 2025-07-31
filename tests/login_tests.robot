*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://reqres.in

*** Test Cases ***
Successful Login Should Return Token
    Create Session    reqres    ${BASE_URL}
    ${data}=    Create Dictionary    email=eve.holt@reqres.in    password=cityslicka
    ${response}=    POST    reqres    /api/login    json=${data}
    Should Be Equal As Numbers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    token

Unsuccessful Login Should Return Error
    Create Session    reqres    ${BASE_URL}
    ${data}=    Create Dictionary    email=peter@klaven
    ${response}=    POST    reqres    /api/login    json=${data}
    Should Be Equal As Numbers    ${response.status_code}    400
    Dictionary Should Contain Key    ${response.json()}    error

*** Settings ***
Library           RequestsLibrary
Library    ../venv/Lib/site-packages/robot/libraries/Collections.py

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

Delete User Should Return 204
    Create Session    reqres    ${BASE_URL}
    ${response}=    DELETE    reqres    /api/users/2
    Should Be Equal As Numbers    ${response.status_code}    204

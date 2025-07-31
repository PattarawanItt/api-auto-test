*** Settings ***
Library         RequestsLibrary
Library         Collections

*** Variables ***
${BASE_URL}     https://reqres.in
# ${API_KEY}      reqres-free-v1
${PROXY_HOST}   http://proxy.me.com
${PROXY_PORT}   8080 

*** Keywords ***
Create Global Reqres Session
    # &{headers}=    Create Dictionary    x-api-key=${API_KEY}    Content-Type=application/json
    &{headers}=     Create Dictionary    Content-Type=application/json
    Create Session    reqres    ${BASE_URL}    headers=${headers}

*** Test Cases ***
GET SINGLE USER Should Match Schema
    [Tags]    GET
    Create Global Reqres Session
    ${response}=    Get On Session    reqres    /api/users/2
    Should Be Equal As Numbers    ${response.status_code}    200

    ${json_response}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json_response}    data

    ${data_dict}=    Get From Dictionary    ${json_response}    data
    ${expected_keys}=    Create List    id    email    first_name    last_name    avatar
    FOR    ${key}    IN    @{expected_keys}
        Dictionary Should Contain Key    ${data_dict}    ${key}
    END

GET Non-Existent User Should Return 404
    [Tags]    GET    NEGATIVE
    Create Global Reqres Session
    # ทดสอบดึงข้อมูล User ID ที่ไม่มีอยู่จริง (เช่น 999)
    ${response}=    GET On Session    reqres    /api/users/999    expected_status=401
    # status code 401 Unauthorized
    Should Be Equal As Numbers    ${response.status_code}    401

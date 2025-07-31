*** Settings ***
Library         RequestsLibrary
Library         Collections

*** Variables ***
${BASE_URL}     https://petstore.swagger.io/v2
${API_KEY}      special-key
${PET_ID}       9223372036854740480
# ${PET_ID}       9223372036854740484

*** Keywords ***
Create Petstore Session
    Create Session    petstore    ${BASE_URL}
    ...    headers={"Content-Type":"application/json", "accept":"application/json"} 

Create Petstore Session Key
    &{headers}=     Create Dictionary
    ...    Content-Type=application/json
    ...    accept=application/json
    ...    api_key=${API_KEY} 
    Create Session    petstore    ${BASE_URL}    headers=&{headers}

*** Test Cases ***
Post - Create New Pet Should Succeed
    [Tags]    PET    POST    POSITIVE
    Create Petstore Session
    # 1. สร้าง Dictionary ของ category
    &{category_dict}=    Create Dictionary    id=${1}    name=Dogs
    # 2. สร้าง Dictionary ของ tag
    &{tag_dict}=         Create Dictionary    id=${1}    name=friendly
    # 3. สร้าง List ของ tags
    @{tags_list}=        Create List          ${tag_dict}
    # 4. สร้าง List ของ photoUrls
    @{photo_urls_list}=  Create List          https://example.com/fido.jpg
    # 5. ประกอบทุกส่วนเข้าเป็น Payload หลัก
    &{payload}=     Create Dictionary
    ...    id=${0}                         # id=0 -> create new
    ...    name=Fido                   
    ...    category=${category_dict}      
    ...    photoUrls=${photo_urls_list}  
    ...    tags=${tags_list}             
    ...    status=available

    # sert request
    ${response}=    POST On Session    petstore    /pet    json=${payload}

    # 1. check status code : 200 OK
    Should Be Equal As Numbers    ${response.status_code}    200

    # 2. check response body
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal As Strings       ${json_response['name']}          Fido
    Should Be Equal As Strings       ${json_response['status']}        available
    Should Be Equal As Strings       ${json_response['category']['name']}  Dogs
    Should Not Be Equal As Numbers   ${json_response['id']}            0    # ID ที่ได้กลับมาต้องไม่เป็น 0
    Log To Console    Created pet with new ID: ${json_response['id']}

Get - Pet By Stored ID
    [Tags]    PET    GET
    [Setup]    Create Petstore Session

    ${response}=    GET On Session    petstore    /pet/${PET_ID}
    Should Be Equal As Numbers    ${response.status_code}    200

    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json_response['name']}    doggie
    Should Be Equal As Numbers    ${json_response['id']}      ${PET_ID}

Put - Pet By Stored ID
    [Tags]    PET    UPDATE
    [Setup]    Create Petstore Session

    &{category_dict}=    Create Dictionary    id=${1}    name=Cats
    &{tag_dict}=         Create Dictionary    id=${2}    name=mischievous
    @{tags_list}=        Create List          ${tag_dict}
    @{photo_urls_list}=  Create List          https://example.com/kitty.jpg

    &{updated_payload}=     Create Dictionary
    ...    id=${PET_ID}
    ...    name=Garfield
    ...    status=sold                     
    ...    category=${category_dict}      
    ...    photoUrls=${photo_urls_list}     
    ...    tags=${tags_list}           

    ${response}=    PUT On Session    petstore    /pet    json=${updated_payload}
    Should Be Equal As Numbers    ${response.status_code}    200

    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json_response['status']}    sold
    Log To Console    Updated pet ${PET_ID} status to: sold

Delete - Pet And Verify Deletion
    [Tags]    PET    DELETE
    [Setup]    Create Petstore Session Key

    ${response}=    DELETE On Session    petstore    /pet/${PET_ID}
    Should Be Equal As Numbers    ${response.status_code}    200

    ${verify_response}=    GET On Session    petstore    /pet/${PET_ID}    expected_status=404
    Log To Console    Pet ${PET_ID} has been deleted and verified
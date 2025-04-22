*** Settings ***
Library           SeleniumLibrary
Variables    Library.locator_lib    # We are calling variables declared in the locator_lib.py file, In this similar manner we can call any other library written in python


Test Setup    Run Keywords
...    Open Browser    ${URL}    ${BROWSER}    AND
...    Maximize Browser Window

Test Teardown    Close Browser


*** Variables ***
${URL}            https://the-internet.herokuapp.com/login
${BROWSER}        Chrome
${USERNAME}       tomsmith
${PASSWORD}       SuperSecretPassword!

*** Keywords ***
Assert And Capture Screenshot Upon Failure
    [Arguments]    ${actual}    ${expected}
   Run Keyword If    """${expected}""" not in """${actual}"""    Run Keywords
    ...    Capture Page Screenshot    AND
    ...    Fail    Expected: ${expected}, but got: ${actual}



*** Test Cases ***
# We will create a test case for valid and invalid login scenarios.
# Suite setup and teardown are already defined in the settings section which takes care of opening and closing the browser.
# We have all the elements declared in a common locator file, considering maintainability and reusability.
# The test cases will use the keywords defined in the locator file to interact with the web elements.
Valid Login
    Wait Until Element Is Visible    ${element_user_name}    10
    Input Text      ${element_user_name}    ${USERNAME}
    Input Text      ${element_password}    ${PASSWORD}
    Click Button    xpath:${element_submit_button}
    Wait Until Element Is Visible    xpath:${element_flash}    10
    ${message}=    Get Text    xpath:${element_flash}
    Assert And Capture Screenshot Upon Failure    ${message}    You logged into a secure area!    # This is a re-usable keyword that captures the screenshot if the assertion fails.

Invalid Login
    Wait Until Element Is Visible    ${element_user_name}    10
    Input Text      ${element_user_name}    wronguser
    Input Text      ${element_password}    wrongpassword
    Click Button    xpath:${element_submit_button}
    Wait Until Element Is Visible    xpath:${element_flash}    10
    ${message}=    Get Text    xpath:${element_flash}
    Assert And Capture Screenshot Upon Failure    ${message}    Your username is invalid!

Invalid Login, But wrong expectation in test case
    Wait Until Element Is Visible    ${element_user_name}    10
    [Documentation]    The user is attempting to log in with valid credentials, but the application unexpectedly returns an incorrect message.
    ...    This demonstrates how a failure occurs when the application's actual behavior doesn't match the test script's expectation.
    ...    The robot framework will report this as a failure and capture the screenshot where the failure occurred.
    Input Text      ${element_user_name}    wronguser    # Assume this is right credential
    Input Text      ${element_password}    wrongpassword
    Click Button    xpath:${element_submit_button}
    Wait Until Element Is Visible    xpath:${element_flash}    10
    ${message}=    Get Text    xpath:${element_flash}
    Assert And Capture Screenshot Upon Failure    ${message}    You logged into a secure area!
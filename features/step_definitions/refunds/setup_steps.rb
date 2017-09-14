
Given(/^I am "Luke Skywalker"$/) do
  address = OpenStruct.new building: '102',
                           street: 'Petty France',
                           locality: 'London',
                           county: 'Greater London',
                           post_code: 'SW1H 9AJ',
                           country: 'United Kingdom'
  self.test_user = OpenStruct.new title: "Mr",
                                  first_name: "Luke",
                                  last_name: "Skywalker",
                                  date_of_birth: '21/11/1985',
                                  address: address,
                                  telephone_number: '01234 567890',
                                  email_address: 'test@digital.justice.gov.uk'
end

And(/^I want a refund for my previous ET claim with case number "1234567\/2016"$/) do
  respondent = OpenStruct.new name: 'Respondent Name',
                              post_code: 'SW1H 9QR'
  representative = OpenStruct.new name: 'Representative Name',
                                  post_code: 'SW2H 9ST'
  fees = OpenStruct.new et_issue_fee: '1000.00',
                        et_issue_payment_method: 'Card',
                        et_hearing_fee: '1001.00',
                        et_hearing_payment_method: 'Cash',
                        eat_issue_fee: '1002.00',
                        eat_issue_payment_method: 'Cheque',
                        eat_hearing_fee: '1003.00',
                        eat_hearing_payment_method: 'Card',
                        app_reconsideration_fee: '1004.00',
                        app_reconsideration_payment_method: 'Card'

  test_user.et_claim_to_refund = OpenStruct.new et_case_number: '1234567/2016',
                                                et_tribunal_office: 'NG0001',
                                                additional_information: 'REF1, REF2, REF3',
                                                respondent: respondent.freeze,
                                                representative: representative.freeze,
                                                fees: fees.freeze

end


And(/^I have a bank account$/) do
  test_user.bank_account = OpenStruct.new account_name: 'Mr Luke Skywalker',
                                          bank_name: 'Starship Enterprises Bank',
                                          account_number: '12345678',
                                          sort_code: '012345'
end


And(/^my name has not changed since the original claim that I want a refund for$/) do
  test_user.has_name_changed = 'No'
end


And(/^my address has not changed since the original claim that I want a refund for$/) do
  test_user.claim_address_same = 'Yes'
end

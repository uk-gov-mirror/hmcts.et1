require 'rails_helper'

feature 'Claim applications', type: :feature do
  include FormMethods
  include Messages
  include EpdqMatchers
  include PdfMethods

  context 'along the happy path' do
    before do
      stub_request(:post, 'https://etapi.employmenttribunals.service.gov.uk/1/fgr-office').
        with(postcode: 'AT1 4PQ').to_return body: fgr_response.to_json
    end

    around do |example|
      stub_request(:get, "https://mdepayments.epdq.co.uk/ncol/test/backoffice?BRANDING=EPDQ&lang=1").
        to_return(:status => 200, :body => "", :headers => {})

      PaymentGateway::TASK.run
      example.run
      PaymentGateway::TASK.stop
    end

    let(:fgr_response) do
      {
        "fgr"               => 511234567800,
        "ETOfficeCode"      => 22,
        "ETOfficeName"      => "Birmingham",
        "ETOfficeAddress"   => "Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU",
        "ETOfficeTelephone" => "0121 600 7780"
      }
    end

    scenario 'Create a new application' do
      start_claim
      expect(page).to have_text claim_heading_for(:password)
    end

    scenario 'Entering word for save and return' do
      start_claim
      expect(page).to_not have_button('Complete later')
      fill_in_password 'green'

      claim = Claim.last
      expect(claim.authenticate 'green').to eq(claim)

      expect(page).to have_text claim_heading_for(:claimant)
      expect(page).to have_button('Complete later')
    end

    scenario 'Entering word and email for save and return' do
      start_claim
      fill_in_password_and_email 'green', 'mail@example.com'

      claim = Claim.last
      expect(claim.authenticate 'green').to eq(claim)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to include(claim.reference)

      expect(page).to have_text claim_heading_for(:claimant)
    end

    scenario 'Entering personal details' do
      start_claim
      fill_in_password
      fill_in_personal_details

      expect(page).to have_text claim_heading_for(:representative)
    end

    scenario 'Entering representative details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_representative_details

      expect(page).to have_text claim_heading_for(:respondent)
    end

    scenario 'Entering employer details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_representative_details
      fill_in_employer_details

      expect(page).to have_text claim_heading_for(:employment)
    end

    scenario 'Entering employment details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_representative_details
      fill_in_employer_details
      fill_in_employment_details

      expect(page).to have_text claim_heading_for(:claim_type)
    end

    scenario 'Entering claim type details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details

      expect(page).to have_text claim_heading_for(:claim_details)
    end

    scenario 'Entering claim details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details

      expect(page).to have_text claim_heading_for(:claim_outcome)
    end

    scenario 'Entering claim outcome details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details
      fill_in_claim_outcome_details

      expect(page).to have_text claim_heading_for(:additional_information)
    end

    scenario 'Entering additonal information' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details
      fill_in_claim_outcome_details
      fill_in_addtional_information

      expect(page).to have_text claim_heading_for(:your_fee)
    end

    scenario 'Entering your fee details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details
      fill_in_claim_outcome_details
      fill_in_addtional_information
      fill_in_your_fee

      expect(page).to have_text review_heading_for(:show)
    end

    scenario 'Emailing confirmation' do
      complete_a_claim seeking_remissions: false
      select_recipients

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq [FormMethods::CLAIMANT_EMAIL, FormMethods::REPRESENTATIVE_EMAIL, 'bob@example.com', 'jane@example.com']
      expect(email.body).to include completion_message(Claim.last.reference)
      expect(email.body).not_to include 'Download PDF file'
    end

    scenario 'Submitting the claim when payment is not required' do
      pending 'pending design changes in progress there is no way to indicate applying for remission'
      complete_a_claim
      click_button 'Submit the form'

      expect(page.html).to include completion_message(Claim.last.reference)
      expect(page.html).not_to include table_heading('fee_paid')
      expect(page.html).not_to include table_heading('fee_to_pay')
      expect(page.html).to include remission_help
    end

    scenario 'Downloading the PDF' do
      complete_a_claim seeking_remissions: true
      click_button 'Submit the form'
      click_link 'Download PDF file'

      expect(page.response_headers['Content-Type']).to eq "application/pdf"
      expect(pdf_to_hash(page.body)).to eq(YAML.load(File.read('spec/support/et1_pdf_example.yml')))
    end

    scenario 'Making payment' do
      complete_a_claim seeking_remissions: false
      click_button 'Submit the form'

      expect(page).to have_epdq_form
    end

    scenario 'Returning from the payment page' do
      complete_a_claim seeking_remissions: false
      click_button 'Submit the form'

      return_from_payment_gateway

      expect(page.html).to include table_heading('fee_paid')
      expect(page.html).not_to include table_heading('fee_to_pay')
      expect(page.html).not_to include remission_help
    end

    scenario 'Submitting the claim when payment failed' do
      complete_a_claim seeking_remissions: false
      click_button 'Submit the form'

      return_from_payment_gateway('decline')

      expect(page.html).to include completion_message(Claim.last.reference)
      expect(page.html).not_to include table_heading('fee_paid')
      expect(page.html).to include table_heading('fee_to_pay')
      expect(page.html).not_to include remission_help
    end
  end
end

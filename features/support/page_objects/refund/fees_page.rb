module Refunds
  class FeesPage < BasePage
    section :original_claim_fees, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("About your fees paid")]]}) do
      section :et_issue, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("ET Issue fee")]]}) do
        section :fee, AppTest::FormInput, '.refunds_fees_et_issue_fee'
        section :payment_date, AppTest::FormPaymentDate, '.refunds_fees_et_issue_fee_payment_date'
        section :payment_method, AppTest::FormSelect, '.refunds_fees_et_issue_fee_payment_method'
      end
      section :et_hearing, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("ET Hearing fee")]]}) do
        section :fee, AppTest::FormInput, '.refunds_fees_et_hearing_fee'
        section :payment_date, AppTest::FormPaymentDate, '.refunds_fees_et_hearing_fee_payment_date'
        section :payment_method, AppTest::FormSelect, '.refunds_fees_et_hearing_fee_payment_method'
      end
      section :et_reconsideration, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("ET Reconsideration fee")]]}) do
        section :fee, AppTest::FormInput, '.refunds_fees_et_reconsideration_fee'
        section :payment_date, AppTest::FormPaymentDate, '.refunds_fees_et_reconsideration_fee_payment_date'
        section :payment_method, AppTest::FormSelect, '.refunds_fees_et_reconsideration_fee_payment_method'
      end
      section :eat_issue, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("EAT Issue fee")]]}) do
        section :fee, AppTest::FormInput, '.refunds_fees_eat_issue_fee'
        section :payment_date, AppTest::FormPaymentDate, '.refunds_fees_eat_issue_fee_payment_date'
        section :payment_method, AppTest::FormSelect, '.refunds_fees_eat_issue_fee_payment_method'
      end
      section :eat_hearing, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("EAT Hearing fee")]]}) do
        section :fee, AppTest::FormInput, '.refunds_fees_eat_hearing_fee'
        section :payment_date, AppTest::FormPaymentDate, '.refunds_fees_eat_hearing_fee_payment_date'
        section :payment_method, AppTest::FormSelect, '.refunds_fees_eat_hearing_fee_payment_method'
      end
    end
    element :save_and_continue, 'form.edit_refunds_fees input[value="Continue"]'
  end
end

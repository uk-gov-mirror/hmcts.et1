class ClaimantForm < Form
  include AddressAttributes

  attributes :first_name, :last_name, :date_of_birth, :address_country,
             :mobile_number, :fax_number, :email_address, :special_needs,
             :title, :gender, :contact_preference,
             :applying_for_remission

  booleans   :has_special_needs, :has_representative

  date       :date_of_birth

  validates :title, :gender, :first_name, :last_name, :address_country, :contact_preference, presence: true

  validates :title, inclusion: { in: FormOptions::TITLES.map(&:to_s) }
  validates :gender, inclusion: { in: FormOptions::GENDERS.map(&:to_s) }
  validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
  validates :contact_preference, inclusion: { in: FormOptions::CONTACT_PREFERENCES.map(&:to_s) }
  validates :mobile_number, :fax_number, length: { maximum: PHONE_NUMBER_LENGTH }
  validates :address_country, inclusion: { in: FormOptions::COUNTRIES.map(&:to_s) }
  validates :fax_number,    presence: { if: -> { contact_preference.fax? } }
  validates :email_address, presence: { if: -> { contact_preference.email? } }, length: { maximum: EMAIL_ADDRESS_LENGTH }

  def contact_preference
    (attributes[:contact_preference] || "").inquiry
  end

  def has_special_needs
    @has_special_needs ||= special_needs.present?
  end

  def has_representative
    @has_representative ||= resource.representative.present?
  end

  private def target
    resource.claimants.first || resource.claimants.build
  end
end

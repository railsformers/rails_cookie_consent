module RailsCookieConsent
  module CookieHelper
    LEVEL_KEY = 'level'.freeze

    def cookie_consent?(key)
      return false if raw_cookie_consent.blank?

      consent = parsed_consent
      consent.present? && consent[LEVEL_KEY].present? && consent[LEVEL_KEY].include?(key.to_s)
    end

    def consent_levels
      consent = parsed_consent
      consent.present? && consent[LEVEL_KEY].present? ? consent[LEVEL_KEY] : []
    end

    def cookie_consent_link(options = {})
      link_to(I18n.t('rails_cookie_consent.link_text'), 'javascript:void(0);', data: { cc: 'c-settings' }, class: options[:class], remote: options[:remote])
    end

    def raw_cookie_consent
      return if cookies.nil?

      cookies[RailsCookieConsent.config.cookie_name]
    end

    def parsed_consent
      begin
        JSON.parse(raw_cookie_consent)
      rescue JSON::ParserError
        cookies.delete(RailsCookieConsent.config.cookie_name) if raw_cookie_consent.present?
        nil
      end
    end
  end
end

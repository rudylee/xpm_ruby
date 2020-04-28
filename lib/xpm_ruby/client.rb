require_relative "models/client"

module XpmRuby
  module Client
    extend self

    module GstPeriod
      ONE = "1"
      TWO = "2"
      SIX = "6"
    end

    module GstBasis
      INVOICE = "Invoice"
      PAYMENT = "Payment"
      HYBRID = "Hybrid"
    end

    module ProvisionalTaxBasis
      STANDARD_OPTION = "Standard Option"
      ESTIMATE_OPTION = "Estimate Option"
      RATIO_OPTION = "Ratio Option"
    end

    module AgencyStatus
      WITH_EOT = "With EOT"
      WITHOUT_EOT = "Without EOT"
      UNLINKED = "Unlinked"
    end

    module ReturnType
      IR3 = "IR3"
      IR3NR = "IR3NR"
      IR4 = "IR4"
      IR6 = "IR6"
      IR7 = "IR7"
      IR9 = "IR9"
      PTS = "PTS"
    end

    module Contact
      extend self

      def build(**args)
        Models::Client::Contact.new(args)
      end
    end

    def build(**args)
      Models::Client.new(args)
    end

    def add(api_key:, account_key:, api_url:, client:)
      builder = ::Nokogiri::XML::Builder.new do |xml|
        xml.Client do
          xml.Name do
            xml.text(client.name)
          end
        end
      end

      response = Connection
        .new(api_key: api_key, account_key: account_key, api_url: api_url)
        .post(endpoint: "client.api/add", data: builder.doc.root.to_xml)

      case response.status
      when 401
        hash = Ox.load(response.body, mode: :hash_no_attrs, symbolize_keys: false)

        raise Unauthorized.new(hash["html"]["head"]["title"])
      when 200
        hash = Ox.load(response.body, mode: :hash_no_attrs, symbolize_keys: false)

        case hash["Response"]["Status"]
        when "OK"
          Client.build(
            uuid: hash["Response"]["Client"]["UUID"],
            name: hash["Response"]["Client"]["Name"],
            email: hash["Response"]["Client"]["Email"])
        when "ERROR"
          raise Error.new(response["ErrorDescription"])
        end
      else
        raise Error.new(response.status)
      end
    end
  end
end

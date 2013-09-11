require 'swiftype/configuration'
require 'swiftype/result_set'
require 'swiftype/easy/request'

module Swiftype
  class Easy

    include Swiftype::Easy::Request

    # Create a new Swiftype::Easy client
    #
    # @param options [Hash] a hash of configuration options that will overrided what is set on the Swiftype class.
    # @option options [String] :api_key an API Key to use for this client
    # @option options [String] :platform_access_token a user's access token, will be used instead of API key for authenticating requests
    def initialize(options={})
      @options = options
    end

    def api_key
      @options[:api_key] || Swiftype.api_key
    end

    def platform_access_token
      @options[:platform_access_token]
    end

    module Engine
      def engines
        get("engines.json")
      end

      def engine(engine_id)
        get("engines/#{engine_id}.json")
      end

      def create_engine(name)
        post("engines.json", :engine => {:name => name})
      end

      def destroy_engine(engine_id)
        delete("engines/#{engine_id}.json")
      end

      def suggest(engine_id, query, options={})
        search_params = { :q => query }.merge(options)
        response = post("engines/#{engine_id}/suggest.json", search_params)
        ResultSet.new(response)
      end

      def search(engine_id, query, options={})
        search_params = { :q => query }.merge(options)
        response = post("engines/#{engine_id}/search.json", search_params)
        ResultSet.new(response)
      end
    end

    module DocumentType
      def document_types(engine_id)
        get("engines/#{engine_id}/document_types.json")
      end

      def document_type(engine_id, document_type_id)
        get("engines/#{engine_id}/document_types/#{document_type_id}.json")
      end

      def create_document_type(engine_id, name)
        post("engines/#{engine_id}/document_types.json", :document_type => {:name => name})
      end

      def destroy_document_type(engine_id, document_type_id)
        delete("engines/#{engine_id}/document_types/#{document_type_id}.json")
      end

      def suggest_document_type(engine_id, document_type_id, query, options={})
        search_params = { :q => query }.merge(options)
        response = post("engines/#{engine_id}/document_types/#{document_type_id}/suggest.json", search_params)
        ResultSet.new(response)
      end

      def search_document_type(engine_id, document_type_id, query, options={})
        search_params = { :q => query }.merge(options)
        response = post("engines/#{engine_id}/document_types/#{document_type_id}/search.json", search_params)
        ResultSet.new(response)
      end
    end

    module Document
      def documents(engine_id, document_type_id, page=nil, per_page=nil)
        options = {}
        options[:page] = page if page
        options[:per_page] = per_page if per_page
        get("engines/#{engine_id}/document_types/#{document_type_id}/documents.json", options)
      end

      def document(engine_id, document_type_id, document_id)
        get("engines/#{engine_id}/document_types/#{document_type_id}/documents/#{document_id}.json")
      end

      def create_document(engine_id, document_type_id, document={})
        post("engines/#{engine_id}/document_types/#{document_type_id}/documents.json", :document => document)
      end

      def create_documents(engine_id, document_type_id, documents=[])
        post("engines/#{engine_id}/document_types/#{document_type_id}/documents/bulk_create.json", :documents => documents)
      end

      def destroy_document(engine_id, document_type_id, document_id)
        delete("engines/#{engine_id}/document_types/#{document_type_id}/documents/#{document_id}.json")
      end

      def destroy_documents(engine_id, document_type_id, document_ids=[])
        post("engines/#{engine_id}/document_types/#{document_type_id}/documents/bulk_destroy.json", :documents => document_ids)
      end

      def create_or_update_document(engine_id, document_type_id, document={})
        post("engines/#{engine_id}/document_types/#{document_type_id}/documents/create_or_update.json", :document => document)
      end

      def create_or_update_documents(engine_id, document_type_id, documents=[])
        post("engines/#{engine_id}/document_types/#{document_type_id}/documents/bulk_create_or_update.json", :documents => documents)
      end

      def update_document(engine_id, document_type_id, document_id, fields)
        put("engines/#{engine_id}/document_types/#{document_type_id}/documents/#{document_id}/update_fields.json", { :fields => fields })
      end

      def update_documents(engine_id, document_type_id, documents={})
        put("engines/#{engine_id}/document_types/#{document_type_id}/documents/bulk_update.json", { :documents => documents })
      end
    end

    module Analytics
      def analytics_searches(engine_id, from=nil, to=nil)
        get("engines/#{engine_id}/analytics/searches.json", date_range(from, to))
      end

      def analytics_autoselects(engine_id, from=nil, to=nil)
        get("engines/#{engine_id}/analytics/autoselects.json", date_range(from, to))
      end

      def analytics_top_queries(engine_id, page=nil, per_page=nil)
        options = {}
        options[:page] = page if page
        options[:per_page] = per_page if per_page
        get("engines/#{engine_id}/analytics/top_queries.json", options)
      end

      def analytics_top_queries_in_range(engine_id, from=nil, to=nil)
        get("engines/#{engine_id}/analytics/top_queries_in_range.json", date_range(from, to))
      end

      def analytics_top_no_result_queries(engine_id, from=nil, to=nil)
        get("engines/#{engine_id}/analytics/top_no_result_queries_in_range.json", date_range(from, to))
      end

      private
      def date_range(from, to)
        options = {}
        options[:start_date] = from if from
        options[:end_date] = to if to
        options
      end
    end

    module Domain
      def domains(engine_id)
        get("engines/#{engine_id}/domains.json")
      end

      def domain(engine_id, domain_id)
        get("engines/#{engine_id}/domains/#{domain_id}.json")
      end

      def create_domain(engine_id, url)
        post("engines/#{engine_id}/domains.json", {:domain => {:submitted_url => url}})
      end

      def destroy_domain(engine_id, domain_id)
        delete("engines/#{engine_id}/domains/#{domain_id}.json")
      end

      def recrawl_domain(engine_id, domain_id)
        put("engines/#{engine_id}/domains/#{domain_id}/recrawl.json")
      end

      def crawl_url(engine_id, domain_id, url)
        put("engines/#{engine_id}/domains/#{domain_id}/crawl_url.json", {:url => url})
      end
    end

    module Clickthrough
      def log_clickthrough(engine_id, document_type, q, id)
        post(
          "engines/#{engine_id}/document_types/#{document_type}/analytics/log_clickthrough.json",
          {:q => q, :id => id}
        )
      end
    end

    include Swiftype::Easy::Engine
    include Swiftype::Easy::DocumentType
    include Swiftype::Easy::Document
    include Swiftype::Easy::Analytics
    include Swiftype::Easy::Domain
    include Swiftype::Easy::Clickthrough
  end
end

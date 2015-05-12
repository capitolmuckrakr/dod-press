require 'tmpdir'
require 'open-uri'
require 'nokogiri'
require 'ensure/encoding'

  class TranscriptPage
    
    attr_accessor :download_dir

    attr_reader :transcript_page_id
    
    def initialize(transcript_page_id,opts={})
      @transcript_page_id = transcript_page_id
      #@opts = opts
      @download_dir = opts[:download_dir] || Dir.tmpdir
    end
    
    def transcript_url_base
      'http://www.defense.gov/Transcripts/Transcript.aspx?TranscriptID='
    end
    
    def filing_url
      transcript_url_base + transcript_page_id.to_s
    end
    
    def file_path
      File.join(download_dir.to_s, file_name.to_s)
    end

    def file_name
      "#{transcript_page_id}.htm"
    end    
    
    def download_page
      File.open(file_path, 'w') do |file|
        open(filing_url) do |filing|
            begin
              file << filing.read
            rescue
              file << filing.read.ensure_encoding('UTF-8', :external_encoding => Encoding::UTF_8,:invalid_characters => :drop)
            end
        end
      end
      self
    end
    
    def read_page
      @page = Nokogiri::XML(File.open(file_path, 'r'))
      return @page
    end
    
  end
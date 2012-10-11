require 'net/imap'
require 'mail'
require 'pp'

module CucumberSelenium::GMail
  DEFAULTS = { :delete => false,
               :host => "imap.gmail.com",
               :port => 993,
               :ssl => true,
               :count => 5 }

  # Will get you the newest 5 emails from your GMail inbox
  # Returns a array of mails. For each mail....
  #
  # mail.envelope.from   #=> 'mikel@test.lindsaar.net'
  # mail.from.addresses  #=> ['mikel@test.lindsaar.net', 'ada@test.lindsaar.net']
  # mail.sender.address  #=> 'mikel@test.lindsaar.net'
  # mail.to              #=> 'bob@test.lindsaar.net'
  # mail.cc              #=> 'sam@test.lindsaar.net'
  # mail.subject         #=> "This is the subject"
  # mail.date.to_s       #=> '21 Nov 1997 09:55:06 -0600'
  # mail.message_id      #=> '<4D6AA7EB.6490534@xxx.xxx>'
  # mail.body.decoded    #=> 'This is the body of the email...
  def self.getn(username, password, opts={})
    opts.merge!(DEFAULTS)
    Mail.defaults do
      retriever_method(:imap,
                       :user_name  => username,
                       :password   => password,
                       :address    => opts[:host],
                       :port       => opts[:port],
                       :enable_ssl => opts[:ssl])
    end
    return Mail.find(:what => :first, :count => opts[:count], :order => :desc)
  end

  # Will delete the supplied email from your GMail inbox
  def self.delete(username, password, mail, opts={})
    Mail.find(:keys => "HEADER Message-ID #{mail.message_id}", :delete_after_find => true, :read_only => true)
  end
end

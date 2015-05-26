# Mailer For Delphi

Mailing tool aimed for simplicity, for sending e-mails of any complexity in Delphi. This includes e-mails with plain text and/or html content, embedded images and separate attachments, SMTP, SMTPS / SSL and SMTP + SSL. The Mailer4Delphi provides a driver-independent framework to build mail and messaging applications.

The e-mail message structure is built to work with all e-mail clients and has been tested with many different webclients as well as some mainstream client applications such as MS Outlook or Mozilla Thunderbird.


# Mailer Adapters Drivers #

The Mailer4Delphi is available for the following drivers:

- Indy
- MAPI
- Synapse

You can use the driver that suits you best.

# Using Mailer4Delphi #

Using this API will is very simple, you simply add the Search Path of your IDE or your project the following directories:

- Mailer4Delphi\src

Of course, you must add the path the units of the chosen driver.

Example of use:

    uses
      Mailer4D, Mailer4D.Driver.Indy;
    
    var
      vMailer: IMailer;
    begin
      // Here you can create from any driver.
      vMailer := TIndyMailerFactory.Build;
      vMailer.Host('smtp.example.com')
    	.Port(587)
    	.UserName('mailer@example.com')
    	.Password('password')
    	.From('Test', 'mailer@example.com')
    	.ToRecipient('recipient@testrecipient.com')
    	.CcRecipient('ccrecipient@testccrecipient.com')
    	.BccRecipient('bccrecipient@testbccrecipient.com')
    	.Attachment('C:\File.txt')
    	.Subject('Subject Test')
    	.Message('Message Test')
    	.Send;
    end;
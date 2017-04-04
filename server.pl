#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Mojolicious::Lite;
use 5.20.0;
use experimental 'signatures';

# Render template "index.html.ep" from the DATA section
get '/' => {template => 'index'};

# WebSocket service used by the template to extract the title from a web site
websocket '/title' => sub ($c) {
        $c->on(message => sub ($c, $msg) {
                my $title = $c->ua->get($msg)->result->dom->at('title')->text;
                $c->send($title);
            })
    };

any ['GET','POST'] => '/v1/smsservice/customer/:customerid/number/:numberid/message/:messagecontent' => sub {
        my $c = shift;
        # my $customer = $c->stash('customerid');
        my $message = $c->stash('messagecontent');

        # Ensure that client is authenticated
        # if (!IsAuthenticated($customerid)
            # $c->render(template => denied);

        # Ensure that message is not more than 144 character
         require helper;
         my $success = helper::IsValidMessageSize($message);
         if ($success){
             SendMessage($message);
         }

        $c->render(text => "Message sent");
    };

# Sends the actual message
sub SendMessage {
    my $message = @_;
    # Connect to providers api to send the message
}

# Not found (404)
get '/missing' => sub { shift->render(template => 'does_not_exist') };

# Exception (500)
get '/dies' => sub { die 'Intentional error' };

app->start;
__DATA__


@@ index.html.ep
% my $url = url_for 'title';
<script>
  var ws = new WebSocket('<%= $url->to_abs %>');
  ws.onmessage = function (event) { document.body.innerHTML += event.data };
  ws.onmessage = function (event) { document.body.innerHTML += event.data };
  ws.onopen    = function (event) { ws.send('http://mojolicious.org') };
</script>

@@ denied.html.ep
You do not have permission to use this service, please contact support at 1300 100 100.
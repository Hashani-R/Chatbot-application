<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" integrity="sha512-SzlrxWUlpfuzQ+pcUCosxcglQRNAq/DZjVsC0lE40xsADsfeQoEypE+enwcOiGjk/bSuGGKHEyjSoQ1zVisanQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="Styles/chat--app.css" />
        <title>Message Page</title>
    </head>
    <body>
        <div class="chat-wrapper">
            <div class="chatbox">
                <div class="message-container" id="message-container"></div>
                <div class="prompt">
                    <input id="message" type="text" placeholder="Your message..." />
                    <button onclick="send()"><i class="fa fa-paper-plane"></i></button>
                </div>
            </div>
        </div>
        
        <script>
            function send() {
                let messageBox = document.getElementById('message');
                let messageContainer = document.getElementById('message-container');
                
                $.ajax({
                    url: 'MessageHub',
                    data: { message: messageBox.value },
                    type: 'POST',
                    beforeSend: () => {
                        let myMessageElem = '<div class="message-row-me">' +
                            '<div class="message">' +
                                '<div>You</div>' + messageBox.value +
                            '</div>' +
                        '</div>';
                        messageContainer.innerHTML += myMessageElem;
                        messageBox.value = null;
                    },
                    success: (reply) => { 
                        let replyeElem = '<div class="message-row-end">' +
                            '<div class="message">' +
                                '<div>ChatGPT</div>' + reply +
                            '</div>' +
                        '</div>';
                        messageContainer.innerHTML += replyeElem;
                    },
                    error: () => { alert('Something went wrong!') }
                });
            }
        </script>
    </body>
</html>

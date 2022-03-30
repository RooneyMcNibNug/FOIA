## Long-term plan is to use the MuckRock API to grab variables from the request in question
## and automate appeal write-ups here.
#
## For now, this takes stdin and passes it to the variables within the template to form a 
## proper write-up for one of your request.
#
## Have your original FOIA submissions and ack response from the agency handy here.

echo -n "The date of your request: "
read date

echo -n "The identification number provided for your request: "
read id

echo -n "What agency did you file this request to?"
read agency

echo -n "On what date did you receive your first response to this request?: "
read rdate

echo -n "Paste parts of the last response to this request (relevant to why you are appealing) here:"
read finresp

echo -n "Provide reasoning for your appeal here (succintly):"
read reas

message= "Hello,
>
>This is an appeal under the Freedom of Information Act.
>
>On $date, I requested documents from $agency under the Freedom of Information Act. My request was assigned the following identification number: $id. On $rdate I received a response to my request, which was the following:
>
>$finrep
>
>I am appealing for the following reason:
>
>$reas
>
>Attached you will find my original request.
>
>Thank you for your consideration of this appeal.
>- J. Ader"

echo $message

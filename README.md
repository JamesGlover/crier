Crier
=======
Crier is simple-dashboard to help track and manage user acceptance testing environments.

In this early version, updating and creating messages can be handled through curl.

### Example curl commands

Retrieve all messages

    curl localhost:9292/messages --noproxy localhost -H 'Accept:application/json'

Retrieve a single message

    curl localhost:9292/messages/welcome_to_crier --noproxy localhost -H 'Accept:application/json'

Post a message

    curl -X POST localhost:9292/messages --noproxy localhost -H 'Accept:application/json' -F name=example_note -F body="This is an example body" -F types[]=success

Delete a message

    curl -X DELETE localhost:9292/messages/example_note --noproxy localhost -H 'Accept:application/json'

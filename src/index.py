def lambda_handler(event, context):
    print("event")
    print(event)
    print("context")
    print(context)

    return { 
        'body' : '{ "key": "value" }'
    }  
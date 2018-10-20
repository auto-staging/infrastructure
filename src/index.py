def lambda_handler(event, context):
    print("event")
    print(event)
    print("context")
    print(context)

    if not event['body']:
        return { 
            'body' : '{ "method": "'+event['httpMethod']+'", "path": "'+event['path']+'"}'
        }  
    else:
        return { 
            'body' : '{ "method": "'+event['httpMethod']+'", "path": "'+event['path']+'", "body": '+event['body']+'}'
        } 
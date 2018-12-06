import os
import sys
from slackclient import SlackClient

if __name__ == '__main__':
    slack_token = os.environ['SLACK_BOT_TOKEN']
    sc = SlackClient(slack_token)

    message = "*{}*: {} _*{}*_: {}".format(
        sys.argv[2],
        sys.argv[3],
        sys.argv[1],
        sys.argv[4]
    )
    print("Going to send: " + message)


    response = sc.api_call(
        "chat.postMessage",
        channel="ewatercycle-infra",
        text=message,
        user="ewatercycle_notifier"
    )

    print(response)

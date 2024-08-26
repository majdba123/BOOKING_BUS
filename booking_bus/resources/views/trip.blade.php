<!DOCTYPE html>

<head>
    <title>Pusher Test</title>
    <script src="https://js.pusher.com/8.2.0/pusher.min.js"></script>
    <script>
        // Enable pusher logging - don't include this in production
        Pusher.logToConsole = true;

        var pusher = new Pusher('7342c00647f26084d14f', {
            cluster: 'ap2'
        });

        var channel = pusher.subscribe('trip_channel');
        channel.bind('NewTrip', function(data) {
            alert(JSON.stringify(data));
        });
    </script>

</head>

<body>
    <h1>Notification Test</h1>
    <p>
        Try Notification an event to channel <code>my-channel</code>
        with event name <code>my-event</code>.
    </p>
</body>

<!DOCTYPE html>

<head>
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>user Test</title>
    @vite(['resources/sass/app.scss', 'resources/js/app.js'])
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>
    <script src="https://js.pusher.com/8.2.0/pusher.min.js"></script>
    <script>
        // Enable pusher logging - don't include this in production
        Pusher.logToConsole = true;
        var pusher = new Pusher('7342c00647f26084d14f', {
            cluster: 'ap2',
            authEndpoint: '/pusher/auth', // updated endpoint
            auth: {
                params: {
                    userId: '{{ auth()->id() }}' // pass the user ID to the auth endpoint
                }
            }
        });

        var channel = pusher.subscribe('notification-private-channel-{{ auth()->id() }}');
        channel.bind('PrivateNotification', function(data) {
            alert(JSON.stringify(data));
        });
    </script>
</head>

<body>
    <h1> user Test</h1>
    <h1>User ID: {{ auth()->user()->id }}</h1>
    <p>
        Try Notification an event to channel <code>user.{{ auth()->user()->id }}</code>
        with event name <code>my-event</code>.
    </p>
    <div id="notifications">
        <!-- notifications will be displayed here -->
    </div>
</body>

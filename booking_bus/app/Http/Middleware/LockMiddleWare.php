<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Lock; // <--- Add this line
class LockMiddleWare
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $busTripId = $request->route('id');
        $lock = Lock::block($busTripId, 5); // 5 seconds timeout
        if ($lock) {
            try {
                return $next($request);
            } finally {
                Lock::restore($busTripId);
            }
        } else {
            return response()->json(['message' => 'Failed to book seat. Try again later.'], 500);
        }
    }
}

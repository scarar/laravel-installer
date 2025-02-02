<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use GuzzleHttp\Client;

class TorController extends Controller
{
    public function testTor()
    {
        $client = new Client([
            'proxy' => 'socks5h://127.0.0.1:9050',
            'verify' => false
        ]);

        try {
            $response = $client->get('http://hh2icganql7uh3azl2y2v6opyqhpws5u2cquif5icuuxpfsnkqqcdayd.onion');
            return response($response->getBody()->getContents());
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
}

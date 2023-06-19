<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Support\Facades\DB;

class HomeController extends Controller {

    public function index() {
        // foreach (User::all() as $user) {
        //     var_dump($user->name);
        // }
        dd(DB::select("SHOW TABLES"));

        return view('welcome');
    }
}
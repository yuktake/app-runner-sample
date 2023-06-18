<?php

namespace App\Http\Controllers;

use App\Models\User;

class HomeController extends Controller {

    public function index() {
        foreach (User::all() as $user) {
            var_dump($user->name);
        }

        return view('welcome');
    }
}
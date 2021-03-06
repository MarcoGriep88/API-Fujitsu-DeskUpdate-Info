<?php

/** @var \Laravel\Lumen\Routing\Router $router */

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/


$router->get('/version', function () use ($router) {
    return $router->app->version();
});

$router->get('/ping', function () use ($router) {
    return response()->json(['message' => 'ok'], 200);
});
$router->get('/', 'Controller@index');
$router->post('/create', 'Controller@create');
$router->post('/clear', 'Controller@clear');
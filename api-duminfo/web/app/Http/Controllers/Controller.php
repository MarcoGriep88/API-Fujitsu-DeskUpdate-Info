<?php

namespace App\Http\Controllers;

use Laravel\Lumen\Routing\Controller as BaseController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

use App\DUMInfo;
use Response;

class Controller extends BaseController
{
    function __construct() {   }

    public function index() {
        $result = DUMInfo::all();
        return response()->json($result);
    }

    public function show_by_id($id) {
        $result = DUMInfo::where("id", $id)->first();
        return response()->json($result);
    }

    public function create(Request $request) {        
        $checkElems = DUMInfo::where('Hostname', $request->Hostname)
                ->where('Driver', $request->Driver)
                ->where('UpgradeVersion', $request->UpgradeVersion)
                ->first();

        if ($checkElems!=null)
        {
            return "Already exists";
        }

        $obj = new DUMInfo;

        $obj->Hostname = $request->Hostname;
        $obj->Driver = $request->Driver;
        $obj->UpgradeVersion = $request->UpgradeVersion;

        $obj->save();
        
        return $obj;
    }

    public function clear(Request $request) {       
        try {
            DUMInfo::where('Hostname', $request->Hostname)->delete();
            return "ok";
        } 
        catch (Exception $e) {
            return "failed";
        }
    }
}

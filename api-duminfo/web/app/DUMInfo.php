<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class DUMInfo extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'duminfos';

    protected $fillable = array(
        'id',
        'Hostname',
        'Driver',
        'UpgradeVersion'
    );
}
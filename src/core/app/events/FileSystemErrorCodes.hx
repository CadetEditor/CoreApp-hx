  // =================================================================================================    //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.events;

class FileSystemErrorCodes
{public static inline var WRITE_FILE_ERROR : Int = 0;public static inline var READ_FILE_ERROR : Int = 1;public static inline var DELETE_FILE_ERROR : Int = 2;public static inline var CREATE_DIRECTORY_ERROR : Int = 3;public static inline var NOT_A_DIRECTORY : Int = 4;public static inline var GET_DIRECTORY_CONTENTS_ERROR : Int = 5;public static inline var DOES_FILE_EXIST_ERROR : Int = 6;public static inline var DIRECTORY_DOES_NOT_EXIST : Int = 7;public static inline var FILE_DOES_NOT_EXIST : Int = 8;public static inline var DIRECTORY_ALREADY_EXISTS : Int = 9;public static inline var SET_METADATA_ERROR : Int = 10;public static inline var GET_METADATA_ERROR : Int = 11;public static inline var DELETE_METADATA_ERROR : Int = 12;public static inline var GENERIC_ERROR : Int = 13;public static inline var OPERATION_NOT_SUPPORTED : Int = 14;

    public function new()
    {
    }
}
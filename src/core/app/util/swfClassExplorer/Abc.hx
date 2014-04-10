/*
The MIT License

Copyright (c) 2008 Flassari.is

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/package core.app.util.swfclassexplorer;

import core.app.util.swfclassexplorer.AbcNamespace;
import core.app.util.swfclassexplorer.AbcQName;
import core.app.util.swfclassexplorer.ByteArray;
import core.app.util.swfclassexplorer.MultiName;
import core.app.util.swfclassexplorer.ParameterizedQName;
import core.app.util.swfclassexplorer.Traits;
import core.app.util.swfclassexplorer.data.*;import nme.utils.ByteArray;class Abc
{private var publicNs : AbcNamespace = new AbcNamespace("");private var anyNs : AbcNamespace = new AbcNamespace("*");private var strings : Array<Dynamic>;private var namespaces : Array<Dynamic>;private var nssets : Array<Dynamic>;private var names : Array<Dynamic>;public var instances : Array<Dynamic>;public function new(br : ByteArray, offset : Int)
    {br.position = offset + 4;while (br.readUnsignedByte() > 0){ }  // Seek past the name  ;var magic : Int = br.readInt();if (magic != (46 << 16 | 14) && magic != (46 << 16 | 15) && magic != (46 << 16 | 16))             return  // Not an Abc block  ;parsePool(br);seekPastMethodInfos(br);seekPastMetadata(br);parseInstanceInfos(br);
    }private function seekPastMethodInfos(br : ByteArray) : Void{names[0] = new AbcQName("*", publicNs);var method_count : Int = readU32(br);for (i in 0...method_count){var param_count : Int = readU32(br);readU32(br);for (j in 0...param_count){readU32(br);
            }readU32(br);var flags : Int = br.readUnsignedByte();if ((flags & 0x08) > 0) {var optional_count : Int = readU32(br);for (k in param_count - optional_count...param_count){readU32(br);br.position++;
                }
            }if ((flags & 0x80) > 0) {for (param_count){readU32(br);
                }
            }
        }
    }private function seekPastMetadata(br : ByteArray) : Void{var count : Int = readU32(br);for (i in 0...count){readU32(br);var values_count : Int = readU32(br);for (q in 0...values_count * 2){readU32(br);
            }
        }
    }private function parseInstanceInfos(br : ByteArray) : Void{var count : Int = readU32(br);instances = new Array<Dynamic>(count);for (i in 0...count){var t : Traits = new Traits();instances[i] = t;t.name = names[readU32(br)];t.baseName = names[readU32(br)];t.flags = br.readUnsignedByte();if ((t.flags & 0x08) > 0)                 readU32(br);var interface_count : Int = readU32(br);t.interfaces = new Array<Dynamic>(interface_count);for (j in 0...interface_count){t.interfaces[j] = names[readU32(br)];
            }readU32(br);seekPastTraits(br);
        }
    }private function seekPastTraits(br : ByteArray) : Void{var namecount : Int = readU32(br);for (i in 0...namecount){readU32(br);var tag : Int = br.readUnsignedByte();var kind : Int = (tag & 0xf);if (kind == 0x00 || kind == 0x06 || kind == 0x04) {readU32(br);if (kind == 0x00 || kind == 0x06) {readU32(br);if (readU32(br) > 0)                         br.readByte();
                }
                else {readU32(br);
                }
            }
            else if (kind == 0x01 || kind == 0x02 || kind == 0x03) {readU32(br);readU32(br);
            }var attr : Int = (tag >> 0x04);if (attr == 0x04) {var mdCount : Int = readU32(br);for (j in 0...mdCount){readU32(br);
                }
            }
        }
    }private function parsePool(br : ByteArray) : Void{var n : Int;
        var i : Int;  // Seek past the various datatypes  n = readU32(br);  // ints  for (n){readU32(br);
        }n = readU32(br);  // uints  for (n){readU32(br);
        }n = readU32(br);  // doubles  for (n){br.readDouble();
        }n = readU32(br);  // strings  strings = new Array<Dynamic>(n);if (n > 0)             strings[0] = "";for (n){strings[i] = readUTFBytes(br);
        }n = readU32(br);  // namespaces  namespaces = new Array<Dynamic>(n);if (n > 0)             namespaces[0] = publicNs;for (n){

            switch (br.readUnsignedByte())
            {case 0x08, 0x16, 0x17, 0x18, 0x19, 0x1a:namespaces[i] = new AbcNamespace(strings[readU32(br)]);case 0x05:readU32(br);namespaces[i] = new AbcNamespace("private", null);
            }
        }n = readU32(br);nssets = new Array<Dynamic>(n);if (n > 0)             nssets[0] = null;for (n){var count : Int = readU32(br);var nsset : Array<Dynamic> = new Array<Dynamic>(count);nssets[i] = nsset;for (j in 0...count){nsset[j] = namespaces[readU32(br)];
            }
        }n = readU32(br);names = new Array<Dynamic>(n);if (n > 0)             names[0] = null;namespaces[0] = anyNs;strings[0] = "*";for (n){

            switch (br.readUnsignedByte())
            {case 0x07, 0x0D:{var ri : AbcNamespace = namespaces[readU32(br)];var lname : String = strings[readU32(br)];names[i] = new AbcQName(lname, ri);
                }case 0x0F, 0x10:names[i] = new AbcQName(strings[readU32(br)]);case 0x11, 0x12:names[i] = null;case 0x13, 0x14:names[i] = new AbcQName("", new AbcNamespace(""));case 0x09, 0x0E:{var localName : String = strings[readU32(br)];names[i] = new MultiName(nssets[readU32(br)], localName);
                }case 0x1B, 0x1C:names[i] = new MultiName(nssets[readU32(br)], "");case 0x1D:{var name : AbcQName = names[readU32(br)];var cnt : Int = readU32(br);var params : Array<Dynamic> = new Array<Dynamic>(count);for (cnt){var idx : Int = readU32(br);params[j] = names[idx];
                    }names[i] = new ParameterizedQName(name, params);
                }
            }
        }namespaces[0] = publicNs;strings[0] = "*";
    }private function readUTFBytes(br : ByteArray) : String{var len : Int = readU32(br);return br.readUTFBytes(len);
    }private function readU32(br : ByteArray) : Int{var result : Int = br.readUnsignedByte();if ((result & 0x00000080) == 0)             return result;result = result & 0x0000007f | br.readUnsignedByte() << 7;if ((result & 0x00004000) == 0)             return result;result = result & 0x00003fff | br.readUnsignedByte() << 14;if ((result & 0x00200000) == 0)             return result;result = result & 0x001fffff | br.readUnsignedByte() << 21;if ((result & 0x10000000) == 0)             return result;return result & 0x0fffffff | br.readUnsignedByte() << 28;
    }
}
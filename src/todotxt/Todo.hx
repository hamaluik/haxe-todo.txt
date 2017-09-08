package todotxt;

import haxe.Unserializer;
import haxe.Serializer;
using Lambda;

class Todo {
    private var source:String;
    public var tasks:Array<Task>;

    private static var newLine:String = {
        #if sys
        if(Sys.systemName() == "Windows") '\r\n';
        else #end '\n';
    };

    public function new(?source:String) {
        this.source = source;
        parse(this.source);
    }

    public function parse(source:String):Void {
        tasks = new Array<Task>();
        if(source == null) return;
        this.source = source;
        tasks = source.split('\n').map(function(l:String):Task { return new Task(l); });
    }

    public function render():String {
        return tasks.map(function(t:Task):String { return t.render(); }).join(newLine);
    }

    @:keep
    function hxSerialize(s:Serializer) {
        s.serialize(render());
    }

    @:keep
    function hxUnserialize(u:Unserializer) {
        var content:String = u.unserialize();
        parse(content);
    }
}
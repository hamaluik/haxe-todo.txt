package todotxt;

import haxe.Serializer;
import haxe.Unserializer;

using StringTools;

/**
 *  A task in a todo.txt TODO list
 */
class Task {
    /**
      Whether the task has been completed or not
     */
    public var completed:Bool = false;

    /**
      The priority of the task, limited to the characters A-Z
     */
    public var priority:String = null;

    /**
      The date the task was started
     */
    public var startedOn:Date = null;

    /**
      The date the task was completed
     */
    public var completedOn:Date = null;

    /**
      The description of the task (including inlined projects and contexts)
     */
    public var description:String = "";

    /**
      A list of all projects tagged in the task
     */
    public var projects:Array<String> = new Array<String>();

    /**
      A list of all contexts tagged in the task
     */
    public var contexts:Array<String> = new Array<String>();

    private static var rCompleted:EReg = ~/^x /;
    private static var rPriority:EReg = ~/^\(([A-Z])\) /;
    private static var twoDates:EReg = ~/^([0-9][0-9][0-9][0-9])\-([0-9][0-9])\-([0-9][0-9]) ([0-9][0-9][0-9][0-9])\-([0-9][0-9])\-([0-9][0-9]) /;
    private static var oneDate:EReg = ~/^([0-9][0-9][0-9][0-9])\-([0-9][0-9])\-([0-9][0-9]) /;
    private static var rProject:EReg = ~/ \+([^\r\n\t ]+)/g;
    private static var rContext:EReg = ~/ @([^\r\n\t ]+)/g;

    /**
      Constructs a new task
      @param line If this is given, it is passed to `parse()` and run immediately
     */
    public function new(?line:String) {
        if(line != null) parse(line);
    }

    /**
      Utility for constructing a new task in code
      @param completed Wheter the task has been completed or not
      @param priority The priority of the task (`A-Z`)
      @param startedOn When the task was started
      @param completedOn When thet ask was completed
      @param description The description of the task including inline projects and contexts
      @return Task
     */
    public static function assemble(completed:Bool, priority:Null<String>, startedOn:Null<Date>, completedOn:Null<Date>, description:String):Task {
        var task = new Task();

        task.completed = completed;
        task.priority = priority;
        task.startedOn = startedOn;
        task.completedOn = completedOn;
        task.description = description;
        rProject.map(description, function(r:EReg):String {
            task.projects.push(r.matched(1));
            return r.matched(0);
        });
        rContext.map(description, function(r:EReg):String {
            task.contexts.push(r.matched(1));
            return r.matched(0);
        });

        return task;
    }

    /**
      Parses a todo.txt task line and stores the result in itself
      @param line The todo.txt task line to parse
     */
    public function parse(line:String):Void {
        completed = false;
        priority = null;
        startedOn = null;
        completedOn = null;
        description = "";
        projects = new Array<String>();
        contexts = new Array<String>();

        var _line:String = line.trim();
        if(_line.length < 1) return;

        if(rCompleted.match(_line)) {
            completed = true;
            _line = rCompleted.matchedRight();
        }

        if(rPriority.match(_line)) {
            priority = rPriority.matched(1);
            _line = rPriority.matchedRight();
        }

        if(twoDates.match(_line)) {
            completedOn = new Date(Std.parseInt(twoDates.matched(1)), Std.parseInt(twoDates.matched(2)) - 1, Std.parseInt(twoDates.matched(3)) , 0, 0, 0);
            startedOn = new Date(Std.parseInt(twoDates.matched(4)), Std.parseInt(twoDates.matched(5)) - 1, Std.parseInt(twoDates.matched(6)) , 0, 0, 0);
            _line = twoDates.matchedRight();
        }
        else if(oneDate.match(_line)) {
            startedOn = new Date(Std.parseInt(oneDate.matched(1)), Std.parseInt(oneDate.matched(2)) - 1, Std.parseInt(oneDate.matched(3)) , 0, 0, 0);
            _line = oneDate.matchedRight();
        }

        description = _line;

        rProject.map(description, function(r:EReg):String {
            projects.push(r.matched(1));
            return r.matched(0);
        });

        rContext.map(description, function(r:EReg):String {
            contexts.push(r.matched(1));
            return r.matched(0);
        });
    }

    /**
      Converts the internal task to a plain string to be stored in a todo.txt
      @return String
     */
    public function render():String {
        var ret:String = "";

        if(completed) ret += "x ";
        if(priority != null) ret += '($priority) ';
        if(completedOn != null) {
            if(startedOn == null) startedOn = completedOn;
            ret += DateTools.format(completedOn, '%Y-%m-%d') + ' ';
        }
        if(startedOn != null) ret += DateTools.format(startedOn, '%Y-%m-%d') + ' ';
        ret += description;

        return ret.trim();
    }

    /**
      Convenience utility for `render()`
      @return String
     */
    public function toString():String {
        return render();
    }

    @:keep
    function hxSerialize(s:Serializer) {
        s.serialize(render());
    }

    @:keep
    function hxUnserialize(u:Unserializer) {
        var line:String = u.unserialize();
        parse(line);
    }
}
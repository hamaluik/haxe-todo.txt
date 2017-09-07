package todotxt;

using StringTools;

class Task {
    public var completed:Bool = false;
    public var priority:String = null;
    public var startedOn:Date = null;
    public var completedOn:Date = null;
    public var description:String = "";
    public var projects:Array<String> = new Array<String>();
    public var contexts:Array<String> = new Array<String>();

    private static var rCompleted:EReg = ~/^x /;
    private static var rPriority:EReg = ~/^\(([A-Z])\) /;
    private static var twoDates:EReg = ~/^([0-9][0-9][0-9][0-9])\-([0-9][0-9])\-([0-9][0-9]) ([0-9][0-9][0-9][0-9])\-([0-9][0-9])\-([0-9][0-9]) /;
    private static var oneDate:EReg = ~/^([0-9][0-9][0-9][0-9])\-([0-9][0-9])\-([0-9][0-9]) /;
    private static var rProject:EReg = ~/ \+([^\r\n\t ]+)/g;
    private static var rContext:EReg = ~/ @([^\r\n\t ]+)/g;

    public function new(?line:String) {
        if(line != null) parse(line);
    }

    public function parse(line:String):Void {
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
}
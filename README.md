# todo.txt
[![GitHub license](https://img.shields.io/badge/license-Apache%202-blue.svg?style=flat-square)](https://raw.githubusercontent.com/FuzzyWuzzie/haxe-todo.txt/master/LICENSE) [![Build Status](https://img.shields.io/travis/FuzzyWuzzie/haxe-todo.txt.svg?style=flat-square)](https://travis-ci.org/FuzzyWuzzie/haxe-todo.txt)

Native Haxe utility for reading and writing [todo.txt](http://todotxt.org/) format TODO lists.

## Contributing

Issues, forks, and pull requests are gladly welcomed!

## Documentation

### API

API documentation is available here: http://fuzzywuzzie.github.io/haxe-todo.txt/

### Samples

#### Update a TODO list:

```haxe
import todotxt.Todo;

class Main() {
    public static function main() {
        var list:String = sys.io.File.getContent("todo.txt");
        
        var todo:Todo = new Todo(list);
        todo.tasks.push(Task.assemble(false, 'B', Date.now(), null, 'Order some pizza for the @party'));
        todo.tasks.push(new Task('@party hard!'));

        sys.io.File.saveContent("todo.txt", todo.render());
    }
}
```
this is an example of how you can mix and match modules with literate programming.

Initially we are going to define our data layer using swedn. 

    Person = \swedn
        :name type/string
        :age type/int

Then we are going to set up an html template

    personDiv = \html
        .person
            .age :age
            .name :name

While we're here lets go ahead and set up some styles. 

    \less
        .person { color: red;}


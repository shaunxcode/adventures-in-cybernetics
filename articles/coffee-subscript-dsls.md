#[Adventures in Cybernetics](http://shaunxcode.github.com/shaunxcode)
##Using Coffee-Subscript to create a DSL
Coffee-Subscript is a new project started by the ever prolific ngn (author of the [js APL dialect](https://github.com/ngn/apl)). Initially it used an APL specific notion of Guillemets («») to denote inline APL and a "squiggly arrow" (~>) to denote an APL function. It become apparent that a) the non-ascii character for inline expressions would be problematic for any non-APL users and while the squiggly arrow is cute it would ultimately be better to have one common syntactical approach which allows for the DSL to be defined. 

This led to the latex-esque approach of a backslash followed by the name of the DSL module to be utilized by the preprocessor. In practice this looks like:
		
	countDown = \apl.fn 
		a ← ⍳ 10
		1 + ⌽ a
		
	console.log countDown()

	console.log \apl (2=+⌿0=A∘.∣A)/A←⍳100
	
	doubledNumbers = (\edn [1 2 3]).map \smalltalk.fn [x | x + x]

	person = \swedn
		;swedn is "sweet expression EDN" basically implied maps based on indentation
	    :name "test mctesterson"
	    :pets 
	    	:cat :color/red
	    	:dog :color/black
	    	:badger :color/brown
	    :vehicles jet car bike
	    	
	templated = (\tmpl <div class="person">{{name}}</div>) name: person.get ":name"
	
    query = \datomic.query
    	:find ?e ?name
    	:where ?e :person/name ?name
    
Those are 7 different DSL examples. Each illustrating that the DSL module itself is responsible for the parsing of the string containing the "DSL code" e.g. everything which comes after the DSL is encountered and all subsequent indented lines (or if inline everything else in the parenthetical). 


Obviously in reality you aren't (or are you?) going to be mixing together EDN vectors and smalltalk blocks, but the point is to show how once you are not restricted to one specific syntax switching between languages can actually be a relatively seamless process. Bare in mind this is not meant to replace what lisp macros give you, rather it is intended to allow for the interpolation of what would otherwise be "external" DSLs. 

This starts to make sense when you are utilizing things like datomic in which the schema, data, and query language are entirely composed of data structures (EDN) which in clojure is a thing of beauty. In coffeescript we are either reduced to passing strings around or encoding the json equivelant into EDN. With the DSL approach we can actually not only parse the edn but verify that the query is well formed, the entity attributes exist in the schema etc. 

Rather than jumping into the specific of APL or EDN let's pick on the low hanging fruit which is the \tmpl DSL. This is essentially equivelant to calling:

	_.template "<div class=\"person\">{{name}}</div>"
	
So what we are creating is a way to embed the markup w/o having to worry about the quotation escaping etc. The tmpl module would look like:

	module.exports = compile: (markup) -> "_.template(\"#{markup.replace /"/g, '\\"'}\")"
	
In essence moving our string escaping into one location which is called at preprocess/compile time. This blatantly lacks the elegance of a lisp macro approach via quasiquote, but at the same time we would also not be able to directly embed markup in the lisp code and instead pass along a list structure which closely resembles what we "mean". I think there is merit to both ways of thinking and room to explore both.  
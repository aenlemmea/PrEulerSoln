This document provides tips to help you to write more efficient Maple code. Some of this material is general and applies to programming in most languages, but other points are Maple-specific, or apply only to programming languages that are similar to Maple. 
The first two-and most important-rules of computer program optimization describe when not to optimize. 
1. Do not begin optimizing your code until after you have most of your program designed and working well. 
2. Do not begin optimizing your code until you have thoroughly profiled it. 
Maple now has quite sophisticated profiling facilities that gather fine-grained, execution-time statistics for your application. For more information, see the help topics debugopts, kernelopts, profile, exprofile, and excallgraph. Note the profile option to kernelopts and the traceproc option to debugopts. 
Profiling efforts are not useful early in the development process, except, perhaps, to catch gross errors. Only after your application is nearly functionally complete should you begin profiling your code. Only after rigorous profiling of your code is any attempt at optimization likely to be successful. 
Unlike conventional languages, such as C, Ada, and FORTRAN, Maple is designed for ``evolutionary programming.'' Conventional languages expect that you have well-defined specifications before you begin to write code, and expect the specification to remain unchanged once development begins. Most Maple programmers initially have only a vague idea of the final application functionality. They do not arrive at a final design specification until after they have investigated a number of examples, and tried a few prototypes. This evolutionary approach to development is characteristic of the type of mathematical exploration for which Maple was designed. Early in the development effort, you can focus on interactive testing and modeling of your problem. Only after you have discovered how best to model a problem and present its solution should you profile the code and focus on optimizing it to achieve optimal performance. 
The remainder of this page focuses on concrete tips to help you achieve better performance from your Maple code. Where possible, an explanation as well as a method is given so that you can extrapolate from the information provided here. 

Very few Maple applications are I/O bound and so, on average, 80 percent of the execution time of a Maple application is spent on less than 5 percent of the code. Careful profiling is the only way to determine where this critical 5 percent is located. Use profiling information to determine the sections of your code that take the most time and consume the most storage, then optimize those parts. 

Ensure that you are using the correct algorithm, that is, the best optimization. You can, for example, write a ``quicksort'' algorithm to get O(n*ln(n)) performance in a sorting application. But, if your data is often sorted on input, you can achieve O(n) performance (asymptotically) by checking for a sorted sequence first. 

Avoid useless recomputation. If you must use an explicit loop, study the loop body carefully to determine whether any of the computations can be "factored out" of the loop (that is, computed once, before entering the loop). For example, a loop that has the form: 
> for i from 1 to n do
>     a[ i ] := f( Pi ) / g( i )
> end do;
in which f and g are procedures can be more efficiently written by "factoring out" the computation of f( Pi ). Then the code looks like: 
> s := f( Pi );
> for i from 1 to n do
>     a[ i ] := s / g( i )
> end do;
Of course, if this loop is merely initializing an array a, you should use the following instead. 
> s := f( Pi );
> a := array( 1 .. n, [ seq( s / g( i ), i = 1 .. n ) ] );

Try to avoid excessively recursive procedures. Many recursive routines can be transformed into an iterative style by using loops. (Then, the loops can often be replaced with faster, built-in routines.) 
Consider the standard factorial procedure FACT, defined recursively as: 
> FACT := proc( n::nonnegint )
>     if n < 2 then
>         1
>     else
>         n * FACT( n - 1 )
>     end if
> end proc:
The first step in optimizing this procedure is to transform it into a tail-recursive form. 
> FACT := proc( n::nonnegint )
>     local       afact;
>     afact := proc( m, a )
>         if m < 2 then
>             a
>         else
>             afact( m - 1, m * a )
>         end if
>     end proc;
>     afact( n, 1 )
> end proc:
This method uses a tail-recursive subroutine afact that requires two arguments to store the intermediate results in an accumulator, which is passed to the recursive invocation as the second parameter a. Since it is tail-recursive (and not merely recursive), the subroutine afact is an iteration, and can be rewritten as a loop. 
> FACT := proc( n::nonnegint )
>     local       afact, m;
>     afact := 1;
>     for m from 1 to n do
>         afact := afact * m
>     end do;
>     afact;
> end proc:
In this case, the replacement of the loop with a call to mul does not necessarily lead to a performance improvement. It improves performance for moderately large arguments, but for extremely large numbers, garbage collection begins to affect performance. Performance degrades because the products formed at each loop iteration are purely numeric, and so the amount of ``garbage'' created at each loop iteration is ``constant''. (This is not quite true; the size of the integers allocated does indeed grow, but an integer has no internal pointers for the garbage collector to follow, so reclamation of garbage integers uses a bounded amount of stack space during garbage collection.) Whether a version of FACT based on mul is faster than the last version above is platform dependent. 

Set the Digits environment variable to a value appropriate for your computations. Maple provides unlimited precision floating-point arithmetic, but many applications of floating-point computations do not require high-precision computation, and the cost of computation rises with the value of Digits. Be aware that many routines include special code for floating-point computations at settings of Digits that are below the hardware precision. If you want to plot cos( x ) over the interval x = -Pi..Pi, do not use Digits:=100. 

A general rule of thumb-one that does not apply universally-is that you achieve greater efficiency by employing a functional style that avoids side-effects instead of an imperative style. Traditional, imperative languages such as C and FORTRAN encourage you to create objects too early, forcing you to update them later as program execution progresses. Modern functional languages like Haskell or ML create objects at the right time, so that side-effects can be avoided. Maple supports both the functional and imperative styles of programming. Generally, however, a functional approach leads to more efficient Maple code. Code that is free of side-effects is much easier to optimize. (One of the first operations performed by most optimizing compilers is to transform a program into a form free of side-effects.) Procedures that have no side-effects are eligible for the remember option. 
Consider the loop example above, in which the computation of a the f( Pi ) term was moved outside of the loop body. The tacit assumption was made that the computation of f( Pi ) was side-effect free. Please note that this optimization requires that the computation of f( Pi ) be free of side-effects. If, for instance, f is defined as 
> f := proc( s )
>     print(HELLO);
>     sin( s )
> end proc:
then the optimization described above would not be valid, because it changes the behavior of the program. Other side-effects are assignments to global, lexically-scoped local variables from an enclosing scope or environment variables; I/O related effects; and "call-by-name" routines that assign a value to one of their arguments before returning to the calling code. 

In some cases, memoize computed values. Maple makes this very easy and convenient by means of the option remember. If you are concerned about the storage used by accumulating values for a frequently called procedure, then include option system. Note that this technique is only for use in computations free of side-effects. 

In some situations, in which you must be very careful with storage costs, a simple memoization technique called "caching" provides a low storage overhead solution that can dramatically improve average case performance. Suppose that you have an expensive procedure f. 
> f := proc()
>     .... # some expensive computation
> end proc:
Introduce a variable, f_cache, that is a global or local variable of a module or procedure in which f is defined. This holds the most recently computed value of f. Also introduce a variable, f_cache_args, to hold the expression sequence of arguments to f that produced the value f_cache. (They must be visible in the body of f.) Now modify the definition of procedure f to resemble the following (assuming that these are lexically scoped local variables): 
> f := proc()
>     if assigned( f_cache ) and [f_cache_args] = [args] then
>         return f_cache
>     end if;
>     ... # original computation
> end proc:
Caching is an example of a specialized optimization that can be highly effective if applied intelligently. 

For Powershell, avoid integer division whenever possible if using implicit types.

# Roku

A toy functional programming language based on Japanese 

## Introduction by example

I can now write the following Haku program:

    # Example Roku program.

    Main {
        LL = \X -> X * X;
        NRs = 77,7100,55;
        X:Y:Z:[] = NRs;
        NNR = X,Y |> +;
        NNR |> show;
        RES = (741 |> LL) + 919;
        (RES,NNR |> +) |> show
    }

and it compiles to the following Scheme code:

    (define (displayln str) (display str) (newline))(define (hon)

    ; Example Roku program.
    
    (define (Main)
        (let* (
                (LL (lambda (X) (* X X )))
                (NRs (list 88 7100 55))
                (X (car NRs))
                (Y (cadr NRs))
                (Z (caddr NRs))
                (NNR (+ X Y ))
                (RES (+ (LL 741) 919 ))
            )
            (displayln NNR)
            (displayln (+ RES NNR ))
        )
    )

    (Main)

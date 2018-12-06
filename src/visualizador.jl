module visualizador
using LightGraphs, SimpleWeightedGraphs
using DelimitedFiles

lim_an_min = 0
lim_la_min = 0
lim_an_max = 0
lim_la_max = 0
extra = 10
    #Funcion que obtiene el string de los segmentos
    function segmentos(arbol)
        grafica = arbol[1]
        diccionario = arbol[2]
        resultado = ""
        for e in edges(grafica)
            origen = e.src
            destin = e.dst
            punto1 = diccionario[origen]
            punto2 = diccionario[destin]
            resultado = string(resultado,"<polyline points=\"",(punto1[1] + lim_an_min)*extra ,",",(punto1[2] + lim_la_min)*extra, " ",(punto2[1]+ lim_an_min)*extra,",",(punto2[2]+ lim_la_min)*extra,"\" style=\"fill:none;stroke:black;stroke-width:2\" />\n")
        end
        vertices = nv(grafica)
        #Grafica de los puntos
        for i in 1:vertices
            punto = diccionario[i]
            resultado = string(resultado,"<circle cx=\"",(punto[1] + lim_an_min)*extra,"\" cy=\"",(punto[2] + lim_la_min)*extra,"\" r=\"1.2\" stroke=\"tomato\" stroke-width=\"0.2\" fill=\"tomato\" />\n")
        end
        return resultado
    end

    "Funcion que calcula los limites del canvas dado los puntos del arbol"
    function pon_limites(arbol)
        vertices = nv(arbol[1])
        diccionario = arbol[2]
        min_x = Inf
        max_x = -Inf
        max_y = -Inf
        min_y = Inf
        for i in 1:vertices
            punto = diccionario[i]
            if punto[1]<min_x
                min_x = punto[1]
            end
            if punto[1]>max_x
                max_x = punto[1]
            end
            if punto[2]<min_y
                min_y = punto[2]
            end
            if punto[2]>max_y
                max_y = punto[2]
            end
        end
        global lim_an_min = abs(min_x)+2
        global lim_la_min = abs(min_y)+2
        global lim_an_max = abs(max_x)
        global lim_la_max = abs(max_y)
    end

    #Arbol tiene el diccionario y la grafica resultante
    function grafica_arbol(arbol, nombre_archivo)
        archivo = open(string(nombre_archivo,".svg"), "a")
        pon_limites(arbol)
        inicio = string("<!DOCTYPE html>\n<html>\n<body> \n <svg height=\"",(lim_la_max+ lim_la_min)*extra +10,"\" width=\"", (lim_an_max + lim_an_min)*extra +10 ,"\" style=\"background: powderblue\">\n")
        fin = "</svg></body>\n</html>"
        seg = segmentos(arbol)
        write(archivo,string(inicio,seg,fin))
        close(archivo)
    end
end

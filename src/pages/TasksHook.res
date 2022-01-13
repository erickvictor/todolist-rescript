module Task = {
  type t = {
    id: int,
    name: string,
    completed: bool,
    createdAt: string,
  }

  let codec = Jzon.object4(
    ({id, name, completed, createdAt}) => (id, name, completed, createdAt),
    ((id, name, completed, createdAt)) => Ok({
      id: id,
      name: name,
      completed: completed,
      createdAt: createdAt,
    }),
    Jzon.field("id", Jzon.int),
    Jzon.field("name", Jzon.string),
    Jzon.field("completed", Jzon.bool),
    Jzon.field("createdAt", Jzon.string),
  )
}

module Fetch = {
  type response

  @send external json: response => Js.Promise.t<Js.Json.t> = "json"
  @val external fetch: (string, {..}) => Js.Promise.t<response> = "fetch"
}

let {queryOptions, useQuery} = module(ReactQuery)

let apiUrl = "http://localhost:3001"
let apiCodec = Jzon.array(Task.codec)

let handleFetch = _ => {
  open Promise

  Fetch.fetch(`${apiUrl}/tasks`, {"method": "GET"})
  ->then(response => Fetch.json(response))
  ->thenResolve(json => Jzon.decodeWith(json, apiCodec))
}

type requestResult = 
  | Data(array<Task.t>)
  | Loading
  | Error

let useTasks = () => {
  let result = useQuery(
    queryOptions(
      ~queryKey="tasks",
      ~queryFn=handleFetch,
      ~refetchOnWindowFocus=ReactQuery.refetchOnWindowFocus(#bool(false)),
      (),
    ),
  )

  switch result {
  | { isLoading: true } => Loading
  | { isError: true } 
  | { data: Some(Error(_)) } => Error
  | { data: Some(Ok(tasks)), isLoading: false, isError: false} => Data(tasks)
  | _ => Error
  }
}

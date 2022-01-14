let {queryOptions, useQuery} = module(ReactQuery)

let apiUrl = "http://localhost:3001"
let apiCodec = Jzon.array(TaskTypes.codec)

let handleFetch = _ => {
  open Promise

  Fetch.fetch(`${apiUrl}/tasks`, {"method": "GET"})
  ->then(response => Fetch.json(response))
  ->thenResolve(json => Jzon.decodeWith(json, apiCodec))
}

type requestResult =
  | Data(array<TaskTypes.t>)
  | Loading
  | Error

type hookResult = {
  result: requestResult,
  handleChange: ReactEvent.Form.t => unit,
  taskName: string,
}

let useTasks = () => {
  let (taskName, setTaskName) = React.useState(_ => "")

  let result = useQuery(
    queryOptions(
      ~queryKey="tasks",
      ~queryFn=handleFetch,
      ~refetchOnWindowFocus=ReactQuery.refetchOnWindowFocus(#bool(false)),
      (),
    ),
  )

  let handleChange = event => {
    let target = ReactEvent.Form.target(event)

    setTaskName(_ => target["value"])
  }
  {
    taskName: taskName,
    handleChange: handleChange,
    result: switch result {
    | {isLoading: true} => Loading
    | {isError: true}
    | {data: Some(Error(_))} =>
      Error
    | {data: Some(Ok(tasks)), isLoading: false, isError: false} => Data(tasks)
    | _ => Error
    },
  }
}

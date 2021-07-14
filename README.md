# bigflow-build-tools

## Usage

An example of using actions in a workflow:

### Check
Use `Check` action if you want to run build and tests for the given [bigflow](ttps://github.com/allegro/bigflow) project.  
You can specify `bf_start_time` and `bf_workflow_id` as input parameters. The defaults are `NOW` and `ALL`.
```yaml
...
steps:
  - uses: allegro-actions/bigflow/setup@main
    with:
      bf_start_time: <start_time>
      bf_workflow_id: <workflow_id>
...
```

### Build & Release
If you want to build and prepare images and dags you can use `Build & Release` action. 

```yaml
...
steps:
  - uses: allegro-actions/bigflow/build-and-release@main
    with:
      bf_start_time: <start_time>
      bf_workflow_id: <workflow_id>
      repository_url: <repository_url>
...
```

### Deploy
You can deploy your dags to GCP Airflow with `Deploy` action. It takes two arguments env and GCP vault secret. 
```yaml
...
steps:
  - uses: allegro-actions/bigflow/deploy@main
    with:
      bf_env: <env>
      bf_vault_secret: <secret>
...
```

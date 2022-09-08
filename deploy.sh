#1
gcloud deploy delivery-pipelines delete boutique-demo-app01 --region us-central1 --force

#2
gcloud deploy apply --file=clouddeploy.yaml --region=us-central1

#3
gcloud deploy releases create boutique-enabling-tracing-v01 --source="." --skaffold-file=skaffold-deploy.yaml --skaffold-version=1.39.1 --delivery-pipeline=boutique-demo-app01 --region us-central1
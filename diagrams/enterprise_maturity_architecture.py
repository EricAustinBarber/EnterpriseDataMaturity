from diagrams import Cluster, Diagram, Edge
from diagrams.azure.analytics import Databricks
from diagrams.azure.database import SQLDatabases
from diagrams.azure.devops import Devops
from diagrams.azure.general import Subscriptions
from diagrams.azure.identity import ActiveDirectory
from diagrams.azure.integration import APIManagement, DataFactories
from diagrams.azure.security import KeyVaults
from diagrams.azure.storage import DataLakeStorage
from diagrams.onprem.analytics import Powerbi
from diagrams.onprem.client import Users
from diagrams.onprem.compute import Server
from diagrams.onprem.monitoring import Grafana
from diagrams.programming.framework import React
from diagrams.programming.language import Python, Rust


def build_diagram() -> None:
    graph_attr = {
        "fontsize": "12",
        "pad": "0.3",
        "splines": "spline",
        "nodesep": "0.6",
        "ranksep": "0.8",
    }

    with Diagram(
        "enterprise_data_maturity_application",
        filename="diagrams/out/enterprise_data_maturity_application",
        outformat="png",
        show=False,
        graph_attr=graph_attr,
    ):
        users = Users("Business and Data Users")

        with Cluster("Experience and API"):
            web = React("Next.js Frontend")
            api = Rust("Rust API (axum)")
            apim = APIManagement("Azure API Management")

        with Cluster("Identity and Secrets"):
            entra = ActiveDirectory("Microsoft Entra ID")
            keyvault = KeyVaults("Azure Key Vault")

        with Cluster("Data Platform"):
            adf = DataFactories("Azure Data Factory")
            dbx = Databricks("Azure Databricks")
            lake = DataLakeStorage("ADLS Gen2 / Delta")
            meta = SQLDatabases("Metadata SQL (ADF Logs)")
            pbi = Powerbi("Power BI")

        with Cluster("Governance and Monitoring"):
            bigeye = Grafana("Bigeye")
            alation = Server("Alation")

        with Cluster("DevOps and Platform"):
            devops = Devops("Azure DevOps")
            sub = Subscriptions("Azure Subscription")
            pyspark = Python("PySpark Jobs")

        users >> web >> Edge(label="OIDC/JWT") >> entra
        web >> api >> apim
        api >> Edge(label="Secrets") >> keyvault

        adf >> lake
        adf >> meta
        dbx >> lake
        pyspark >> dbx
        dbx >> pbi

        meta >> bigeye
        lake >> bigeye
        lake >> alation
        pbi >> alation

        devops >> api
        devops >> web
        devops >> dbx
        devops >> adf
        api >> sub
        dbx >> sub
        adf >> sub


if __name__ == "__main__":
    build_diagram()

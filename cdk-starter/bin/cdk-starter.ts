#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import { CdkStarterStack } from "../lib/cdk-starter-stack";
import { PhotoStack } from "../lib/PhotoStack";

const app = new cdk.App();
new CdkStarterStack(app, "CdkStarterStack");
new PhotoStack(app, "PhotoStack");

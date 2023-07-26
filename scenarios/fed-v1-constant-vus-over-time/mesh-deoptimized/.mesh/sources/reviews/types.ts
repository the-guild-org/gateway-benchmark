// @ts-nocheck

import { InContextSdkMethod } from '@graphql-mesh/types';
import { MeshContext } from '@graphql-mesh/runtime';

export namespace ReviewsTypes {
  export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
  _FieldSet: { input: any; output: any; }
  _Any: { input: any; output: any; }
};

export type Review = {
  id: Scalars['ID']['output'];
  body?: Maybe<Scalars['String']['output']>;
  author?: Maybe<User>;
  product?: Maybe<Product>;
};

export type User = {
  id: Scalars['ID']['output'];
  reviews?: Maybe<Array<Maybe<Review>>>;
};

export type Product = {
  upc: Scalars['String']['output'];
  reviews?: Maybe<Array<Maybe<Review>>>;
};

export type _Service = {
  sdl?: Maybe<Scalars['String']['output']>;
};

export type _Entity = Review | User | Product;

export type Query = {
  _entities: Array<Maybe<_Entity>>;
  _service: _Service;
};


export type Query_entitiesArgs = {
  representations: Array<Scalars['_Any']['input']>;
};

  export type QuerySdk = {
      /** undefined **/
  _entities: InContextSdkMethod<Query['_entities'], Query_entitiesArgs, MeshContext>,
  /** undefined **/
  _service: InContextSdkMethod<Query['_service'], {}, MeshContext>
  };

  export type MutationSdk = {
    
  };

  export type SubscriptionSdk = {
    
  };

  export type Context = {
      ["reviews"]: { Query: QuerySdk, Mutation: MutationSdk, Subscription: SubscriptionSdk },
      
    };
}
